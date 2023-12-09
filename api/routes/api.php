<?php
use App\Http\Controllers\Auth\AuthenticationController;
use App\Http\Controllers\Products\ProductsController;
use App\Http\Controllers\Categories\CategoriesController;;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::post('products', [ProductsController::class, 'createProduct'])->middleware('auth:sanctum');

Route::get('/test', function () {
    return response([
        'message' => 'Hello World!'
    ], 200);
});

Route::post('register', [AuthenticationController::class, 'register']);
Route::post('login', [AuthenticationController::class, 'login']);
Route::get('categories', [CategoriesController::class, 'getcategories']);
Route::get('my-products', [ProductsController::class, 'getMyProducts'])->middleware('auth:sanctum');
Route::delete('my-product/{id}', [ProductsController::class, 'deleteProduct'])->middleware('auth:sanctum');
Route::put('my-product/{id}', [ProductsController::class, 'editProduct'])->middleware('auth:sanctum');
Route::get('my-product/{id}', [ProductsController::class, 'getProduct'])->middleware('auth:sanctum');
Route::get('products', [ProductsController::class, 'getProducts']);