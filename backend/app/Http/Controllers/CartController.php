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

		$cartItem = DB::transaction(function () use ($user, $data) {
			$item = CartItem::firstOrNew([
				'user_id' => $user->id,
				'product_id' => $data['product_id'],
			]);
			$item->quantity = ($item->exists ? $item->quantity : 0) + $data['quantity'];
			$item->save();
			return $item->load('product');
		});

		return new CartItemResource($cartItem);
	}

	public function remove(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}
		$item->delete();
		return response()->json([], 204);
	}

	public function updateQuantity(int $id): JsonResponse
	{
		$user = auth()->user();
		$item = CartItem::where('id', $id)->where('user_id', $user->id)->first();
		if (!$item) {
			return response()->json(['message' => 'Not found'], 404);
		}
		$qty = (int) request('quantity', 1);
		if ($qty < 1) {
			$item->delete();
			return response()->json([], 204);
		}
		$item->quantity = $qty;
		$item->save();
		return response()->json([
			'id' => $item->id,
			'quantity' => $item->quantity,
		]);
 	}
}


