<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vendor extends Model
{
    use HasFactory;
    protected $table = "vendors";
    protected $fillable = ['name', 'category_id', 'user_id',  'logo', 'Status'];
    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id', 'category_id');
    }
    public function products()
    {
        return $this->hasMany(Product::class, 'vendor_id', 'vendor_id');
    }
}
