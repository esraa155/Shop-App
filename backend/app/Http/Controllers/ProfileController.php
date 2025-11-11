<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
	/**
	 * Get authenticated user's profile information
	 */
	public function show(): JsonResponse
	{
		$user = Auth::user();
		return response()->json(new UserResource($user));
	}

	/**
	 * Update user's profile information
	 */
	public function update(Request $request): JsonResponse
	{
		$user = Auth::user();
		$validated = $request->validate([
			'name' => 'sometimes|string|max:255',
			'email' => 'sometimes|email|unique:users,email,' . $user->id,
			'avatar' => 'sometimes|string|max:500', // URL or base64
			'phone' => 'sometimes|nullable|string|max:20',
			'address' => 'sometimes|nullable|string|max:500',
			'date_of_birth' => 'sometimes|nullable|date|before:today',
			'city' => 'sometimes|nullable|string|max:100',
			'country' => 'sometimes|nullable|string|max:100',
		]);

		if (isset($validated['name'])) {
			$user->name = $validated['name'];
		}
		if (isset($validated['email'])) {
			$user->email = $validated['email'];
		}
		if (isset($validated['avatar'])) {
			$user->avatar = $validated['avatar'];
		}
		if (isset($validated['phone'])) {
			$user->phone = $validated['phone'];
		}
		if (isset($validated['address'])) {
			$user->address = $validated['address'];
		}
		if (isset($validated['date_of_birth'])) {
			$user->date_of_birth = $validated['date_of_birth'];
		}
		if (isset($validated['city'])) {
			$user->city = $validated['city'];
		}
		if (isset($validated['country'])) {
			$user->country = $validated['country'];
		}

		$user->save();

		return response()->json(new UserResource($user));
	}

	/**
	 * Change user's password
	 */
	public function changePassword(Request $request): JsonResponse
	{
		$user = Auth::user();
		$validated = $request->validate([
			'current_password' => 'required|string',
			'password' => 'required|string|min:8|confirmed',
		]);

		if (!Hash::check($validated['current_password'], $user->password)) {
			return response()->json(['message' => 'Current password is incorrect'], 422);
		}

		$user->password = Hash::make($validated['password']);
		$user->save();

		return response()->json(['message' => 'Password changed successfully']);
	}
}
