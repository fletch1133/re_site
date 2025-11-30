<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('projects', function (Blueprint $table) {
            $table->string('summary_pdf_path')->nullable()->after('pdf_size');
            $table->string('summary_pdf_original_name')->nullable()->after('summary_pdf_path');
            $table->integer('summary_pdf_size')->nullable()->after('summary_pdf_original_name');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('projects', function (Blueprint $table) {
            $table->dropColumn(['summary_pdf_path', 'summary_pdf_original_name', 'summary_pdf_size']);
        });
    }
};

