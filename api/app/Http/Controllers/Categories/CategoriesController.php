<?php

namespace App\Http\Controllers\Categories;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Categories;

class CategoriesController extends Controller
{
    public function getCategories(){
        $categories = Categories::all();
        return response([
            'categories' => $categories,
        ], 201);
    }
}
