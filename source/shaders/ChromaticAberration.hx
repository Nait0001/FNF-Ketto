package shaders;

import openfl.Lib;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

class ChromaticAberration 
{
    public var shader:ChromaticAberrationShader = new ChromaticAberrationShader();
    // public var redOffset(default, set):Float = 0;
    // public var greenOffset(default, set):Float = 0;
    // public var blueOffset(default, set):Float = 0;
    public var offsetColor(default,set):Float = 0;

    public function new(input:Float = 0) 
    {   
        offsetColor = input;
        // shader.iChannel0.value = [iChannel]; 

        // shader.iChannel0.val ue = [];
        // shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
        // shader.iTime.value = [0];
        // shader.iMouse.value = [0];
        // shader.iChannel0 = fuckSample2D;
    }

    public function set_offsetColor(inputOffset:Float):Float {
        var offcolorNum:Float = inputOffset/1000;
        shader.amount.value = [offcolorNum];
        FlxG.log.add(offcolorNum);
        return offcolorNum;
        // trace(offcolorNum);
    }

    // public function set_redOffset(red:Float):Float {
    //     shader.rOffset.value = [red];
    //     return red;
    // }

    // public function set_greenOffset(green:Float):Float {
    //     shader.gOffset.value = [green];
    //     return green;
    // }

    // public function set_blueOffset(blue:Float):Float {
    //     shader.bOffset.value = [blue];
    //     return blue;
    // }

    // public function setRGB(r:Float,g:Float,b:Float){
    //     redOffset = r;
    //     greenOffset = g;
    //     blueOffset = b;
    // }
}


class ChromaticAberrationShader extends FlxShader 
{
    @:glFragmentSource('
        #pragma header
        vec2 uv = openfl_TextureCoordv.xy;
        vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
        vec2 iResolution = openfl_TextureSize;
        uniform float iTime;
        #define iChannel0 bitmap
        #define texture flixel_texture2D
        #define fragColor gl_FragColor
        #define mainImage main
        
        uniform float amount = 0.05;

        void mainImage()
        {
            vec2 uv = fragCoord.xy / iResolution.xy;
    
            
            // amount = (1.0 + sin(iTime*6.0)) * 0.5;
            // amount *= 1.0 + sin(iTime*16.0) * 0.5;
            // amount *= 1.0 + sin(iTime*19.0) * 0.5;
            // amount *= 1.0 + sin(iTime*27.0) * 0.5;
            // amount = pow(amount, 3.0);
                    
            vec3 col;
            col.r = texture( iChannel0, vec2(uv.x+amount,uv.y) ).r;
            col.g = texture( iChannel0, uv ).g;
            col.b = texture( iChannel0, vec2(uv.x-amount,uv.y) ).b;
        
            col *= (1.0 - amount * 0.5);
            
            fragColor = vec4(col,1.0);
            gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
        }
        
        //https://www.shadertoy.com/view/Mds3zn
    ')
    public function new() 
    {
        super();
    }
}