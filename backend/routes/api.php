<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProjectController;
use App\Http\Controllers\Api\ResumeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Test route (no database)
Route::get('/test', function () {
    return response()->json([
        'status' => 'ok',
        'message' => 'API is working!',
        'timestamp' => now()->toIso8601String(),
    ]);
});

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::get('/projects', [ProjectController::class, 'index']);
Route::get('/projects/{id}', [ProjectController::class, 'show']);
Route::get('/resume', [ResumeController::class, 'show']);

// Protected routes (admin only)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Project management
    Route::post('/projects', [ProjectController::class, 'store']);
    Route::post('/projects/{id}', [ProjectController::class, 'update']); // Using POST for file uploads
    Route::delete('/projects/{id}', [ProjectController::class, 'destroy']);

    // Resume management
    Route::post('/resume', [ResumeController::class, 'upload']);
});
