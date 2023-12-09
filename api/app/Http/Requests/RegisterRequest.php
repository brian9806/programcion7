<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'name' => 'required|min:3',
            'last_name' => 'required|min:3',
            'username' => 'required|string|min:3|unique:users',
            'email' => 'required|email|min:3|unique:users',
            'password' => 'required|min:8',
        ];
    }

    public function messages(){
        return[
            'name.required' => 'El nombre es requerido',
            'name.min' => 'El nombre debe tener al menos 3 caracteres',

            'last_name.required' => 'El apellido es requerido',
            'last_name.min' => 'El apellido debe tener al menos 3 caracteres',

            'username.required' => 'El nombre de usuario es requerido',
            'username.min' => 'El nombre de usuario debe tener al menos 3 caracteres',

            'email.required' => 'El correo electronico es requerido',
            'email.min' => 'El correo electronico debe tener al menos 3 caracteres',

            'password.required' => 'La contraseña es requerida',
            'password.min' => 'La contraseña debe tener al menos 8 caracteres',
        ];
    }
}
