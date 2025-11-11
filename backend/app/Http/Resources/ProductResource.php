<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\Product */
class ProductResource extends JsonResource
{
	public function toArray(Request $request): array
	{
		return [
			'id' => $this->id,
			'name' => $this->name,
			'category' => $this->category,
			'description' => $this->description,
			'specifications' => $this->specifications,
			'price' => (float) $this->price,
			'stock' => (int) $this->stock,
			'image_url' => $this->image_url,
			'is_active' => (bool) $this->is_active,
		];
	}
}


