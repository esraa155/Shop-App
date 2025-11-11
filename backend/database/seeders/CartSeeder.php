<?php

namespace Database\Seeders;

use App\Models\CartItem;
use App\Models\Product;
use App\Models\User;
use Illuminate\Database\Seeder;

class CartSeeder extends Seeder
{
	public function run(): void
	{
		$user = User::where('email', 'alice@example.com')->first();
		if (!$user) {
			return;
		}

		$products = Product::where('is_active', true)->take(3)->get();
		foreach ($products as $idx => $product) {
			CartItem::updateOrCreate(
				['user_id' => $user->id, 'product_id' => $product->id],
				['quantity' => $idx + 1]
			);
		}
	}
}


