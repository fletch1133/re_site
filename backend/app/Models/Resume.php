<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Resume extends Model
{
    protected $table = 'resume';

    protected $fillable = [
        'pdf_path',
        'pdf_original_name',
        'pdf_size',
    ];
}
