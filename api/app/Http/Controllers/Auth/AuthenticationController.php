<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Support\Facades\Validator;
use App\Http\Requests\RegisterRequest;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use Illuminate\Http\Request;
use App\Models\User;

class AuthenticationController extends Controller
{
    public function register(Request $request){
        $validator = Validator::make($request->all(),
            RegisterRequest::rules(),
            RegisterRequest::messages()
        );
        if ($validator->fails()) {
            return $validator->errors();
        }

        $validated = $validator->validated();

        $userData = [
            'name' => $request->name,
            'last_name' => $request->last_name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => hash::make($request->password),
        ];

        $user = User::create($userData);
        $token = $user -> createToken('systema&m-app')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ], 201);
    }

    public function login(Request $request){
        $validator = Validator::make($request->all(),
            LoginRequest::rules(),
            LoginRequest::messages()
        );
        if ($validator->fails()) {
            return $validator->errors();
        }

        $user = User::where('username', $request->username)->first();
        if(!$user || !Hash::check($request->password, $user->password)){
            return response([
                'message' => 'Credenciales incorrectas'
            ], 422);
        }

        $token = $user -> createToken('systema&m-app')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ], 201);
    }


}
