<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class productRequest extends FormRequest
{
    public function authorize(){
        return true;
    }

    public function rules(){
        return [
            'name' => 'required|max:255',
            'description' => 'required|max:255',
            'price' => 'required|numeric',
            'stock' => 'required|numeric',
            'image' => 'required|image',
            'category_id' => 'required|numeric',
            'status' => 'required',
        ];
    }

    public function messages(){
        return [
            'name.required' => 'Nombre del producto es requerido',
            'name.max' => 'Nombre del producto es demasiado grande',

            'description.required' => 'Descripcion es requerida',
            'description.max' => 'Descripcion es demasiado grande',


            'price.required' => 'Precio es requerido',
            'price.numeric' => 'Precio debe ser un numero',


            'stock.required' => 'Existencia es requerida',
            'stock.numeric' => 'Existencia debe ser un numero',


            'image.required' => 'Imagen es requerida',
            'image.image' => 'Imagen debe ser una imagen',


            'category_id.required' => 'Categoria es requerida',
            'category_id.numeric' => 'Categoria debe ser un numero',

            'status.required' => 'Estado es requerido',
        ];
    }
}
