<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    protected $fillable = [
        'title',
        'description',
        'pdf_path',
        'pdf_original_name',
        'pdf_size',
        'is_published',
    ];

    protected $casts = [
        'is_published' => 'boolean',
    ];
}
