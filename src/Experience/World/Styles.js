import * as THREE from 'three'
import Experience from '../Experience'
import Vertex from '../Shaders/Style/vertex.glsl?raw'
import Fragment from '../Shaders/Style/fragment.glsl?raw'

export default class Styles
{
    constructor()
    {
        this.experience = new Experience()
        this.scene = this.experience.scene
        this.resources = this.experience.resources
        this.time = this.experience.time
        this.perlinTexture = this.resources.items.perlinTexture
        this.perlinTexture.wrapS = THREE.RepeatWrapping
        this.perlinTexture.wrapT = THREE.RepeatWrapping
        // console.log(this.interactivePlaneTexture.displacement.texture)
        
        this.debug = this.experience.debug

        // setup

        this.subdivisions = 280
        this.count = this.subdivisions * this.subdivisions
        this.size = 24 * 2
        this.fragmentSize = this.size / this.subdivisions
        this.bladeWidth = .2
        this.bladeHeight = .4

        this.setGeometry()
        this.setMaterial()
        this.setGrass()
    }

    /**
     * My Method
     */

    setGeometry()
    {
        // this.geometry = new THREE.PlaneGeometry(280, 280)

        // position array
        const position = new Float32Array(this.count * 3 * 2)
        const randomHeight = new Float32Array(this.count * 3)

        // grid
        for(let X = 0; X < this.subdivisions; X++)
        {
            const normalizeX = (X / this.subdivisions - 0.5) * this.size + this.fragmentSize * 0.5

            for(let Z = 0; Z < this.subdivisions; Z ++)
            {
                const normalizeZ = (Z / this.subdivisions - 0.5) * this.size + this.fragmentSize * 0.5

                // indexs 0 to how many are there
                const i = (X * this.subdivisions + Z)
                const i3 = i * 3 // height
                const i6 = i * 6 // vertex x an z position

                // blade center
                const positionX = normalizeX + (Math.random() - 0.5) * this.fragmentSize
                const positionZ = normalizeZ + (Math.random() - 0.5) * this.fragmentSize

                // vertex 0
                position[i6] = positionX
                position[i6 + 1] = positionZ

                // vertex 1
                position[i6 + 2] = positionX
                position[i6 + 3] = positionZ
                
                // vertex 2
                position[i6 + 4] = positionX
                position[i6 + 5] = positionZ

                // height
                randomHeight[i3] = Math.random()
                randomHeight[i3 + 1] = Math.random()
                randomHeight[i3 + 2] = Math.random()
            }
        }

        this.geometry = new THREE.BufferGeometry()
        this.geometry.boundingSphere = new THREE.Sphere(new THREE.Vector3(), 1)
        this.geometry.setAttribute('position', new THREE.Float32BufferAttribute(position, 2))
        this.geometry.setAttribute('randomHeight', new THREE.Float32BufferAttribute(randomHeight, 1))
    }

    setMaterial()
    {
        // this.material = new THREE.MeshLambertMaterial({
        //     // wireframe: true, 
        //     color: 'yellow'
        // })

        this.material = new THREE.ShaderMaterial({
            vertexShader: Vertex,
            fragmentShader: Fragment,
            uniforms: {
                'uBladeWidth': new THREE.Uniform(this.bladeWidth),
                'uBladeHeight': new THREE.Uniform(this.bladeHeight),

            },
            // wireframe: true
        })
    }

    setGrass()
    {
        this.grass = new THREE.Mesh(this.geometry, this.material)
        this.grass.rotation.x = Math.PI / 2
        
        this.scene.add(this.grass)
    }

    update()
    {
        // time
        // this.material.uniforms.uTime.value = this.time.elapsed
       
    }
}







