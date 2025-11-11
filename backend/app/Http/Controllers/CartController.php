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

		$requestedQuantity = $data['quantity'];
		
		try {
			$cartItem = DB::transaction(function () use ($user, $data, $requestedQuantity) {
				// Lock product for update to prevent race conditions
				$product = Product::where('id', $data['product_id'])
					->where('is_active', true)
					->lockForUpdate()
					->first();
				
				if (!$product) {
					throw new \Exception('Product not found');
				}

				$existingQuantity = CartItem::where('user_id', $user->id)
					->where('product_id', $data['product_id'])
					->value('quantity') ?? 0;
				
				$totalQuantity = $existingQuantity + $requestedQuantity;

				// Check if stock is sufficient
				if ($product->stock < $totalQuantity) {
					throw new \Exception('Insufficient stock. Available: ' . $product->stock);
				}

				$item = CartItem::firstOrNew([
					'user_id' => $user->id,
					'product_id' => $data['product_id'],
				]);
				$item->quantity = ($item->exists ? $item->quantity : 0) + $data['quantity'];
				$item->save();

				// Decrease product stock directly using DB query to ensure it works
				$newStock = $product->stock - $requestedQuantity;
				DB::table('products')
					->where('id', $product->id)
					->update(['stock' => $newStock]);
				
				// Refresh product to get updated stock
				$product->refresh();

				return $item->load('product');
			});

			return new CartItemResource($cartItem);
		} catch (\Exception $e) {
			$message = $e->getMessage();
			if (str_contains($message, 'Product not found')) {
				return response()->json(['message' => $message], 404);
			}
			if (str_contains($message, 'Insufficient stock')) {
				return response()->json(['message' => $message], 422);
			}
			return response()->json(['message' => $message], 500);
		}
	}

	public function remove(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->with('product')->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}

		$quantity = $item->quantity;
		$productId = $item->product_id;

		DB::transaction(function () use ($item, $productId, $quantity) {
			$item->delete();
			// Restore product stock with lock
			$product = Product::where('id', $productId)->lockForUpdate()->first();
			if ($product) {
				$newStock = $product->stock + $quantity;
				DB::table('products')
					->where('id', $productId)
					->update(['stock' => $newStock]);
				$product->refresh();
			}
		});

		return response()->json([], 204);
	}

	public function updateQuantity(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}

		$oldQuantity = $item->quantity;
		$newQuantity = (int) request('quantity', 1);
		$productId = $item->product_id;

		if ($newQuantity < 1) {
			DB::transaction(function () use ($item, $productId, $oldQuantity) {
				$item->delete();
				// Restore product stock with lock
				$product = Product::where('id', $productId)->lockForUpdate()->first();
				if ($product) {
					$newStock = $product->stock + $oldQuantity;
					DB::table('products')
						->where('id', $productId)
						->update(['stock' => $newStock]);
					$product->refresh();
				}
			});
			return response()->json([], 204);
		}

		$quantityDifference = $newQuantity - $oldQuantity;

		try {
			DB::transaction(function () use ($item, $newQuantity, $productId, $quantityDifference) {
				// Lock product for update
				$product = Product::where('id', $productId)->lockForUpdate()->first();
				if (!$product) {
					throw new \Exception('Product not found');
				}

				// Check if stock is sufficient for the increase
				if ($quantityDifference > 0 && $product->stock < $quantityDifference) {
					throw new \Exception('Insufficient stock. Available: ' . $product->stock);
				}

				$item->quantity = $newQuantity;
				$item->save();

				// Update product stock directly using DB query
				if ($quantityDifference > 0) {
					// Decrease stock
					$newStock = $product->stock - $quantityDifference;
					DB::table('products')
						->where('id', $productId)
						->update(['stock' => $newStock]);
				} else {
					// Increase stock (restore)
					$newStock = $product->stock + abs($quantityDifference);
					DB::table('products')
						->where('id', $productId)
						->update(['stock' => $newStock]);
				}
				$product->refresh();
			});

			return response()->json([
				'id' => $item->id,
				'quantity' => $item->quantity,
			]);
		} catch (\Exception $e) {
			$message = $e->getMessage();
			if (str_contains($message, 'Product not found')) {
				return response()->json(['message' => $message], 404);
			}
			if (str_contains($message, 'Insufficient stock')) {
				return response()->json(['message' => $message], 422);
			}
			return response()->json(['message' => $message], 500);
		}
 	}
}


