<?php

namespace Database\Seeders;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OrderSeeder extends Seeder
{
	public function run(): void
	{
		$user = User::where('email', 'bob@example.com')->first();
		if (!$user) {
			return;
		}

		$products = Product::where('is_active', true)->take(4)->get();
		if ($products->isEmpty()) {
			return;
		}

		DB::transaction(function () use ($user, $products) {
			$total = 0;
			$lines = [];
			foreach ($products as $i => $p) {
				$qty = $i + 1;
				$lines[] = [
					'product_id' => $p->id,
					'product_name' => $p->name,
					'unit_price' => $p->price,
					'quantity' => $qty,
				];
				$total += $p->price * $qty;
			}

			$order = Order::create([
				'user_id' => $user->id,
				'total' => $total,
				'status' => 'paid',
			]);

			foreach ($lines as $line) {
				OrderItem::create(array_merge($line, ['order_id' => $order->id]));
			}
		});
	}
}


