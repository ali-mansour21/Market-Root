<?php

use App\Http\Controllers\customer\ConsultAIController;
use App\Http\Controllers\customer\CustomerController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\ProdcutController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('user', [CustomerController::class, 'index']);
Route::post('login-user', [CustomerController::class, 'login']);
Route::post('vendor', [CustomerController::class, 'vendor']);
Route::post('product', [ProdcutController::class, 'index']);
Route::get('home', [HomeController::class, 'index']);
Route::post('home/search', [HomeController::class, 'searchVendorByName']);
Route::post('ask_ai', [ConsultAIController::class, 'consult']);
