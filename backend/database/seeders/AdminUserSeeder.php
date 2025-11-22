<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Only create admin user if it doesn't exist
        if (!User::where('email', env('ADMIN_EMAIL', 'admin@example.com'))->exists()) {
            User::create([
                'name' => env('ADMIN_NAME', 'Admin'),
                'email' => env('ADMIN_EMAIL', 'admin@example.com'),
                'password' => Hash::make(env('ADMIN_PASSWORD', 'password')),
            ]);
        }
    }
}
