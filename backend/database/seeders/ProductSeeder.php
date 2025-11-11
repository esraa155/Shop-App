<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
	/**
	 * Seed products table with sample data
	 * Includes various coffee and beverage products with random stock values
	 */
	public function run(): void
	{
		$products = [
			// Coffee Products
			['name' => 'Espresso', 'description' => 'Strong espresso shot', 'category' => 'Coffee', 'specifications' => 'Single shot, 30ml', 'price' => 2.50, 'image_url' => 'https://picsum.photos/seed/espresso/400/300', 'is_active' => true],
			['name' => 'Latte', 'description' => 'Milk coffee', 'category' => 'Coffee', 'specifications' => 'Espresso with steamed milk, 240ml', 'price' => 3.80, 'image_url' => 'https://picsum.photos/seed/latte/400/300', 'is_active' => true],
			['name' => 'Mocha', 'description' => 'Chocolate flavored coffee', 'category' => 'Coffee', 'specifications' => 'Espresso, chocolate, steamed milk, 240ml', 'price' => 4.20, 'image_url' => 'https://picsum.photos/seed/mocha/400/300', 'is_active' => true],
			['name' => 'Cappuccino', 'description' => 'Espresso with steamed milk foam', 'category' => 'Coffee', 'specifications' => 'Espresso, steamed milk, foam, 180ml', 'price' => 3.20, 'image_url' => 'https://picsum.photos/seed/cappuccino/400/300', 'is_active' => true],
			['name' => 'Americano', 'description' => 'Espresso with hot water', 'category' => 'Coffee', 'specifications' => 'Espresso diluted with hot water, 240ml', 'price' => 2.80, 'image_url' => 'https://picsum.photos/seed/americano/400/300', 'is_active' => true],
			['name' => 'Flat White', 'description' => 'Velvety espresso milk drink', 'category' => 'Coffee', 'specifications' => 'Double espresso, microfoam milk, 180ml', 'price' => 3.60, 'image_url' => 'https://picsum.photos/seed/flatwhite/400/300', 'is_active' => true],
			['name' => 'Cold Brew', 'description' => 'Slow brewed cold coffee', 'category' => 'Coffee', 'specifications' => 'Cold steeped for 12-24 hours, 300ml', 'price' => 4.50, 'image_url' => 'https://picsum.photos/seed/coldbrew/400/300', 'is_active' => true],
			['name' => 'Macchiato', 'description' => 'Espresso with a dollop of foam', 'category' => 'Coffee', 'specifications' => 'Single espresso, milk foam, 60ml', 'price' => 3.00, 'image_url' => 'https://picsum.photos/seed/macchiato/400/300', 'is_active' => true],
			['name' => 'Cortado', 'description' => 'Equal parts espresso and warm milk', 'category' => 'Coffee', 'specifications' => 'Double espresso, warm milk, 120ml', 'price' => 3.40, 'image_url' => 'https://picsum.photos/seed/cortado/400/300', 'is_active' => true],
			['name' => 'Affogato', 'description' => 'Espresso poured over vanilla ice cream', 'category' => 'Coffee', 'specifications' => 'Single espresso, vanilla gelato, 150ml', 'price' => 4.80, 'image_url' => 'https://picsum.photos/seed/affogato/400/300', 'is_active' => true],
			
			// Tea Products
			['name' => 'Matcha Latte', 'description' => 'Green tea with milk', 'category' => 'Tea', 'specifications' => 'Premium matcha powder, steamed milk, 240ml', 'price' => 4.00, 'image_url' => 'https://picsum.photos/seed/matcha/400/300', 'is_active' => true],
			['name' => 'Chai Latte', 'description' => 'Spiced tea with steamed milk', 'category' => 'Tea', 'specifications' => 'Black tea, spices, steamed milk, 240ml', 'price' => 3.90, 'image_url' => 'https://picsum.photos/seed/chai/400/300', 'is_active' => true],
			['name' => 'English Breakfast Tea', 'description' => 'Classic black tea blend', 'category' => 'Tea', 'specifications' => 'Premium black tea leaves, 240ml', 'price' => 2.50, 'image_url' => 'https://picsum.photos/seed/english-tea/400/300', 'is_active' => true],
			['name' => 'Green Tea', 'description' => 'Light and refreshing green tea', 'category' => 'Tea', 'specifications' => 'Japanese sencha green tea, 240ml', 'price' => 2.30, 'image_url' => 'https://picsum.photos/seed/green-tea/400/300', 'is_active' => true],
			['name' => 'Earl Grey', 'description' => 'Black tea with bergamot', 'category' => 'Tea', 'specifications' => 'Black tea, bergamot oil, 240ml', 'price' => 2.60, 'image_url' => 'https://picsum.photos/seed/earl-grey/400/300', 'is_active' => true],
			
			// Other Beverages
			['name' => 'Hot Chocolate', 'description' => 'Rich cocoa drink', 'category' => 'Hot Beverages', 'specifications' => 'Premium cocoa, steamed milk, 240ml', 'price' => 3.00, 'image_url' => 'https://picsum.photos/seed/choco/400/300', 'is_active' => true],
			['name' => 'Caramel Macchiato', 'description' => 'Espresso with caramel and vanilla', 'category' => 'Coffee', 'specifications' => 'Espresso, vanilla syrup, caramel, steamed milk, 240ml', 'price' => 4.50, 'image_url' => 'https://picsum.photos/seed/caramel/400/300', 'is_active' => true],
			['name' => 'Iced Coffee', 'description' => 'Chilled coffee over ice', 'category' => 'Cold Beverages', 'specifications' => 'Cold brew coffee, ice, 350ml', 'price' => 3.50, 'image_url' => 'https://picsum.photos/seed/iced-coffee/400/300', 'is_active' => true],
			['name' => 'Frappuccino', 'description' => 'Blended coffee drink', 'category' => 'Cold Beverages', 'specifications' => 'Coffee, milk, ice, whipped cream, 350ml', 'price' => 4.80, 'image_url' => 'https://picsum.photos/seed/frappuccino/400/300', 'is_active' => true],
			['name' => 'Smoothie', 'description' => 'Fresh fruit blended smoothie', 'category' => 'Cold Beverages', 'specifications' => 'Mixed fruits, yogurt, ice, 350ml', 'price' => 4.20, 'image_url' => 'https://picsum.photos/seed/smoothie/400/300', 'is_active' => true],
		];
		
		// Stock values to cycle through (ensures variety in stock levels)
		$stockValues = [10, 11, 15, 20, 25, 30, 35, 40, 50, 60, 75, 80, 90, 100, 110, 120, 150, 180, 200];
		
		foreach ($products as $index => $data) {
			// Assign stock value cycling through the array
			$data['stock'] = $stockValues[$index % count($stockValues)];
			
			// Update existing products or create new ones
			Product::updateOrCreate(['name' => $data['name']], $data);
		}
	}
}


