<?php

namespace App\Http\Controllers;

use App\Http\Resources\ProductResource;
use App\Models\Favorite;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\ResourceCollection;

class FavoriteController extends Controller
{
	public function index(): ResourceCollection
	{
		$userId = auth()->id();
		$products = Product::whereIn('id', Favorite::where('user_id', $userId)->pluck('product_id'))
			->where('is_active', true)
			->orderByDesc('created_at')
			->paginate(20);
		return ProductResource::collection($products);
	}

	public function toggle(int $productId): JsonResponse
	{
		$userId = auth()->id();
		$product = Product::where('id', $productId)->where('is_active', true)->first();
		if (!$product) {
			return response()->json(['message' => 'Product not found'], 404);
		}
		$existing = Favorite::where('user_id', $userId)->where('product_id', $productId)->first();
		if ($existing) {
			$existing->delete();
			return response()->json(['favorited' => false]);
		}
		Favorite::create(['user_id' => $userId, 'product_id' => $productId]);
	 return response()->json(['favorited' => true]);
	}
}


