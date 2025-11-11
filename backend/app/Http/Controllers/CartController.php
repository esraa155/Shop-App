<?php

namespace App\Http\Controllers;

use App\Http\Requests\Cart\CartAddRequest;
use App\Http\Resources\CartItemResource;
use App\Models\CartItem;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class CartController extends Controller
{
	public function index(): JsonResponse
	{
		$user = auth()->user();
		$items = CartItem::with('product')->where('user_id', $user->id)->get();
		$subtotal = $items->reduce(function ($sum, CartItem $item) {
			return $sum + (($item->product?->price ?? 0) * $item->quantity);
		}, 0);

		return response()->json([
			'items' => CartItemResource::collection($items),
			'subtotal' => $subtotal,
		]);
	}

	public function add(CartAddRequest $request): CartItemResource|JsonResponse
	{
		$user = auth()->user();
		$data = $request->validated();

		$product = Product::query()->where('id', $data['product_id'])->where('is_active', true)->first();
		if (!$product) {
			return response()->json(['message' => 'Product not found'], 404);
		}

		$requestedQuantity = $data['quantity'];
		$existingQuantity = CartItem::where('user_id', $user->id)
			->where('product_id', $data['product_id'])
			->value('quantity') ?? 0;
		
		$totalQuantity = $existingQuantity + $requestedQuantity;

		// Check if stock is sufficient
		if ($product->stock < $totalQuantity) {
			return response()->json([
				'message' => 'Insufficient stock. Available: ' . $product->stock,
				'available_stock' => $product->stock,
			], 422);
		}

		$cartItem = DB::transaction(function () use ($user, $data, $product, $requestedQuantity) {
			$item = CartItem::firstOrNew([
				'user_id' => $user->id,
				'product_id' => $data['product_id'],
			]);
			$item->quantity = ($item->exists ? $item->quantity : 0) + $data['quantity'];
			$item->save();

			// Decrease product stock
			$product->decrement('stock', $requestedQuantity);

			return $item->load('product');
		});

		return new CartItemResource($cartItem);
	}

	public function remove(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->with('product')->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}

		$quantity = $item->quantity;
		$product = $item->product;

		DB::transaction(function () use ($item, $product, $quantity) {
			$item->delete();
			// Restore product stock
			if ($product) {
				$product->increment('stock', $quantity);
			}
		});

		return response()->json([], 204);
	}

	public function updateQuantity(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->with('product')->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}

		$oldQuantity = $item->quantity;
		$newQuantity = (int) request('quantity', 1);

		if ($newQuantity < 1) {
			DB::transaction(function () use ($item, $oldQuantity) {
				$product = $item->product;
				$item->delete();
				// Restore product stock
				if ($product) {
					$product->increment('stock', $oldQuantity);
				}
			});
			return response()->json([], 204);
		}

		$product = $item->product;
		if (!$product) {
			return response()->json(['message' => 'Product not found'], 404);
		}

		$quantityDifference = $newQuantity - $oldQuantity;

		// Check if stock is sufficient for the increase
		if ($quantityDifference > 0 && $product->stock < $quantityDifference) {
			return response()->json([
				'message' => 'Insufficient stock. Available: ' . $product->stock,
				'available_stock' => $product->stock,
			], 422);
		}

		DB::transaction(function () use ($item, $newQuantity, $product, $quantityDifference) {
			$item->quantity = $newQuantity;
			$item->save();

			// Update product stock
			if ($quantityDifference > 0) {
				// Decrease stock
				$product->decrement('stock', $quantityDifference);
			} else {
				// Increase stock (restore)
				$product->increment('stock', abs($quantityDifference));
			}
		});

		return response()->json([
			'id' => $item->id,
			'quantity' => $item->quantity,
		]);
 	}
}


