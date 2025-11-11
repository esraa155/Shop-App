<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
	public function authorize(): bool
	{
		return true;
	}

	public function rules(): array
	{
		return [
			'name' => ['required', 'string', 'max:100'],
			'email' => ['required', 'email', 'unique:users,email'],
			'password' => ['required', 'string', 'min:8', 'confirmed'],
			'phone' => ['nullable', 'string', 'max:20'],
			'address' => ['nullable', 'string', 'max:500'],
			'date_of_birth' => ['nullable', 'date', 'before:today'],
			'city' => ['nullable', 'string', 'max:100'],
			'country' => ['nullable', 'string', 'max:100'],
		];
	}
}


