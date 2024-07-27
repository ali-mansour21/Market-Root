<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserAdress extends Model
{
    use HasFactory;
    protected $table = "addresses";
    protected $fillable = ['user_id', 'street', 'city'];
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
