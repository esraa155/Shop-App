<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
	public function up(): void
	{
		Schema::create('orders', function (Blueprint $table) {
			$table->id();
			$table->foreignId('user_id')->constrained()->cascadeOnDelete();
			$table->decimal('total', 10, 2);
			$table->enum('status', ['pending', 'paid', 'failed', 'cancelled'])->default('paid');
			$table->timestamps();
			$table->index('user_id');
			$table->index('status');
			$table->index('created_at');
		});
	}

	public function down(): void
	{
		Schema::dropIfExists('orders');
	}
};


