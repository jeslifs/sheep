import * as THREE from 'three'
import CustomShaderMaterial from 'three-custom-shader-material/vanilla'
// import Experience from '../Experience'

export default class Material
{
    constructor(Vertex, Fragment, uniforms)
    {
        // this.experience = new Experience()
        // this.scene = this.experience.scene
        // this.time = this.experience.time

        this.setBaseMaterial(Vertex, Fragment, uniforms)
        this.setDepthMaterial(Vertex, uniforms)
    }

    setBaseMaterial(Vertex, Fragment, uniforms)
    {
        this.baseMaterial = new CustomShaderMaterial({

            // CSM
            baseMaterial: THREE.MeshLambertMaterial,
            vertexShader: Vertex,
            fragmentShader: Fragment,
            uniforms: uniforms,
            // side: THREE.DoubleSide
        })
    }

    setDepthMaterial(Vertex, uniforms)
    {
        this.depthMaterial = new CustomShaderMaterial({

            // CSM
            baseMaterial: THREE.MeshDepthMaterial,
            vertexShader: Vertex,
            uniforms: uniforms,
            depthPacking: THREE.RGBADepthPacking,
            // side: THREE.DoubleSide
        })
    }
}