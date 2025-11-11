<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
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

		$user->save();

		return response()->json(new UserResource($user));
	}
}
