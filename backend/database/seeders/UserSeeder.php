<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
	public function run(): void
	{
		$users = [
			[
				'name' => 'Alice',
				'email' => 'alice@example.com',
				'password' => 'password123',
				'phone' => '+1234567890',
				'address' => '123 Main Street, Apt 4B',
				'date_of_birth' => '1990-05-15',
				'city' => 'New York',
				'country' => 'USA',
			],
			[
				'name' => 'Bob',
				'email' => 'bob@example.com',
				'password' => 'password123',
				'phone' => '+1987654321',
				'address' => '456 Oak Avenue, Suite 200',
				'date_of_birth' => '1985-08-22',
				'city' => 'Los Angeles',
				'country' => 'USA',
			],
			[
				'name' => 'Charlie',
				'email' => 'charlie@example.com',
				'password' => 'password123',
				'phone' => '+1122334455',
				'address' => '789 Pine Road',
				'date_of_birth' => '1992-12-10',
				'city' => 'Chicago',
				'country' => 'USA',
			],
		];

		foreach ($users as $data) {
			$user = User::firstOrCreate(['email' => $data['email']], $data);
			// Update existing users with new fields if they don't have them
			if ($user->wasRecentlyCreated === false) {
				$user->update([
					'phone' => $data['phone'] ?? null,
					'address' => $data['address'] ?? null,
					'date_of_birth' => $data['date_of_birth'] ?? null,
					'city' => $data['city'] ?? null,
					'country' => $data['country'] ?? null,
				]);
			}
		}
	}
}


