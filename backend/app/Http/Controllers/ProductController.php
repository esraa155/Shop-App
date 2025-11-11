<?php

namespace App\Http\Controllers;

use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ProductController extends Controller
{
	public function index(): ResourceCollection
	{
		$products = Product::query()
			->where('is_active', true)
			->orderBy('name', 'asc')
			->paginate(request('per_page', 10));

		return ProductResource::collection($products);
	}
}


