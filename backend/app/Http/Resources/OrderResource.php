<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\Order */
class OrderResource extends JsonResource
{
	public function toArray(Request $request): array
	{
		return [
			'id' => $this->id,
			'total' => (float) $this->total,
			'status' => $this->status,
			'created_at' => $this->created_at?->toISOString(),
			'items' => $this->whenLoaded('items', function () {
				return $this->items->map(function ($item) {
					return [
						'product_id' => $item->product_id,
						'product_name' => $item->product_name,
						'unit_price' => (float) $item->unit_price,
						'quantity' => (int) $item->quantity,
						'line_total' => (float) ($item->unit_price * $item->quantity),
					];
				});
			}),
		];
	}
}


