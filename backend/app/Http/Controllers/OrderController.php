<?php

namespace App\Http\Controllers;

use App\Http\Resources\OrderResource;
use App\Models\CartItem;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
	public function checkout(): JsonResponse
	{
		$user = auth()->user();
		$cartItems = CartItem::with('product')->where('user_id', $user->id)->get();
		if ($cartItems->isEmpty()) {
			return response()->json(['message' => 'Cart empty'], 400);
		}

		$order = DB::transaction(function () use ($user, $cartItems) {
			$total = 0;
			foreach ($cartItems as $item) {
				$total += ($item->product?->price ?? 0) * $item->quantity;
			}
			$order = Order::create([
				'user_id' => $user->id,
				'total' => $total,
				'status' => 'paid',
			]);
			foreach ($cartItems as $item) {
				OrderItem::create([
					'order_id' => $order->id,
					'product_id' => $item->product_id,
					'product_name' => $item->product?->name ?? 'N/A',
					'unit_price' => $item->product?->price ?? 0,
					'quantity' => $item->quantity,
				]);
			}
			CartItem::where('user_id', $user->id)->delete();
			return $order->load('items');
		});

		return response()->json(new OrderResource($order), 201);
	}

	public function index(): ResourceCollection
	{
		$orders = Order::with('items')
			->where('user_id', auth()->id())
			->orderByDesc('created_at')
			->paginate(10);
		return OrderResource::collection($orders);
	}
}


