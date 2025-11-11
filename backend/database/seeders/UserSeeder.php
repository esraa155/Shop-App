<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
	public function run(): void
	{
		$users = [
			['name' => 'Alice', 'email' => 'alice@example.com', 'password' => 'password123'],
			['name' => 'Bob', 'email' => 'bob@example.com', 'password' => 'password123'],
			['name' => 'Charlie', 'email' => 'charlie@example.com', 'password' => 'password123'],
		];

		foreach ($users as $data) {
			User::firstOrCreate(['email' => $data['email']], $data);
		}
	}
}


