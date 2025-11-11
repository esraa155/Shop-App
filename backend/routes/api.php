<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

Route::get('/ping', function () {
	return response()->json(['ok' => true]);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/products', [ProductController::class, 'index']);

Route::middleware('auth:sanctum')->group(function () {
	Route::post('/logout', [AuthController::class, 'logout']);

	// Profile routes
	Route::get('/profile', [ProfileController::class, 'show']);
	Route::put('/profile', [ProfileController::class, 'update']);

	Route::get('/cart', [CartController::class, 'index']);
	Route::post('/cart/add', [CartController::class, 'add']);
	Route::delete('/cart/remove/{id}', [CartController::class, 'remove']);
	Route::patch('/cart/update/{id}', [CartController::class, 'updateQuantity']);

	Route::post('/checkout', [OrderController::class, 'checkout']);
	Route::get('/orders', [OrderController::class, 'index']);

	Route::get('/favorites', [FavoriteController::class, 'index']);
	Route::post('/favorites/toggle/{productId}', [FavoriteController::class, 'toggle']);
});


