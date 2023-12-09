<?php

namespace App\Http\Controllers\Products;

use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\Controller;
use App\Models\Products;
use App\Http\Requests\productRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductsController extends Controller
{
    public function createProduct(Request $request){
        print_r($request->all());
        $validator = Validator::make($request->all(),
            productRequest::rules(),
            productRequest::messages()
        );

        if ($validator->fails()) {
            return $validator->errors();
        }

        $validated = $validator->validated();

        $nameImage = preg_replace('/[\/\.]/', '', trim($request->name));
        $nameImage = preg_replace('/\s+/', '-', $nameImage);

        $nameImage = $nameImage.'-'.now()->format('Y-m-d-H-i-s');
        
        $validated['image'] = $request->file('image')->storeAs('products', $nameImage.'.jpg');

        $productData = [
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'stock' => $request->stock,
            'image' => $validated['image'],
            'category_id' => $request->category_id,
            'status' => $request->status
        ];

        auth()->user()->products()->create($productData);

        return response([
            'message' => 'Producto creado exitosamente',
        ], 201);
        
    }

    public function editProduct(Request $request, $productId){
        $product = Products::findOrFail($productId);

        $validator = Validator::make($request->all(),
            ProductRequest::rules(),//validador de imforma
            ProductRequest::messages()
        );

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $validated = $validator->validated();

        if ($request->hasFile('image')) {
            Storage::delete($product->image);
            $nameImage = preg_replace('/[\/\.]/', '', trim($request->name));
            $nameImage = preg_replace('/\s+/', '-', $nameImage);
            $nameImage = $nameImage.'-'.uniqid().'-' . now()->format('Y-m-d-H-i-s');
            $validated['image'] = $request->file('image')->storeAs('products', $nameImage.'.jpg');
        }

        $product->update([
            'name' => $validated['name'],
            'description' => $validated['description'],
            'price' => $validated['price'],
            'stock' => $validated['stock'],
            'image' => $validated['image'],
            'category_id' => $validated['category_id'],
            'status' => $validated['status']
        ]);

        return response([
            'message' => 'Producto actualizado exitosamente',
        ], 201);
    }

    public function deleteProduct($productId){
        $product = Products::findOrFail($productId);

        if ($product->user_id != auth()->id()) {
            return response([
                'message' => 'No tienes permiso para eliminar este producto'
            ], 403);
        }

        Storage::delete($product->image);

        $product->delete();

        return response([
            'message' => 'Producto eliminado exitosamente',
        ], 201);
    }

    private function deleteImage($imagePath){
        if (Storage::exists($imagePath)) {
            Storage::delete($imagePath);
        }
    }

    public function getMyProducts(){
        $user = auth()->user();

        $products = $user->products;
        foreach ($products as $product) {
            $product->image = Storage::url($product->image);
        }

        return response()->json([
            'message' => 'Productos obtenidos exitosamente',
            'data' => $products,
        ], 201);
    }

    public function getProducts(){
        $products = Products::all();

        return response()->json([
            'message' => 'Productos obtenidos exitosamente',
            'data' => $products
        ], 201);
    }

    public function getProduct($productId){
        $product = Products::findOrFail($productId);

        return response()->json([
            'message' => 'Producto obtenido exitosamente',
            'data' => $product
        ], 201);
    }

}
