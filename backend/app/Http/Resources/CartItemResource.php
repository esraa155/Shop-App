<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\CartItem */
class CartItemResource extends JsonResource
{
	public function toArray(Request $request): array
	{
		$product = $this->whenLoaded('product');
		$unitPrice = $product?->price ?? 0;
		return [
			'id' => $this->id,
			'product' => $product ? new ProductResource($product) : null,
			'quantity' => (int) $this->quantity,
			'line_total' => (float) ($unitPrice * $this->quantity),
		];
	}
}


