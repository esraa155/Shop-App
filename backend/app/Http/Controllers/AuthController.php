<?php

namespace App\Http\Controllers;

use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
	public function register(RegisterRequest $request): JsonResponse
	{
		$data = $request->validated();
		$user = User::create([
			'name' => $data['name'],
			'email' => $data['email'],
			'password' => $data['password'],
			'phone' => $data['phone'] ?? null,
			'address' => $data['address'] ?? null,
			'date_of_birth' => $data['date_of_birth'] ?? null,
			'city' => $data['city'] ?? null,
			'country' => $data['country'] ?? null,
		]);
		$token = $user->createToken('mobile')->plainTextToken;
		return response()->json([
			'user' => [
				'id' => $user->id,
				'name' => $user->name,
				'email' => $user->email,
				'avatar' => $user->avatar,
			],
			'token' => $token,
		], 201);
	}

	public function login(LoginRequest $request): JsonResponse
	{
		try {
			$credentials = $request->validated();
			$user = User::where('email', $credentials['email'])->first();
			if (!$user || !Hash::check($credentials['password'], $user->password)) {
				return response()->json(['message' => 'Invalid credentials'], 401);
			}
			$token = $user->createToken('mobile')->plainTextToken;
			return response()->json([
				'user' => [
					'id' => $user->id,
					'name' => $user->name,
					'email' => $user->email,
					'avatar' => $user->avatar,
				],
				'token' => $token,
			]);
		} catch (\Throwable $e) {
			return response()->json(['message' => 'Login error', 'error' => $e->getMessage()], 500);
		}
	}

	public function logout(Request $request): JsonResponse
	{
		$request->user()->currentAccessToken()?->delete();
		return response()->json([], 204);
	}
}


