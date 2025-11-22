<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Log;

Route::get('/', function () {
    return view('welcome');
});

// Simple health check that logs when called
Route::get('/health', function () {
    Log::info('Health check endpoint called');
    return response()->json([
        'status' => 'ok',
        'timestamp' => now()->toIso8601String(),
    ]);
});
