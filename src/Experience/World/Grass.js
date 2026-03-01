import * as THREE from 'three'
import Experience from '../Experience.js'


export default class Grass
{
    constructor()
    {
        this.experience = new Experience()
        this.scene = this.experience.scene
        this.resources = this.experience.resources

        this.debug = this.experience.debug

        // setup
        this.size = 24
        this.plane = 280
        this.count = this.plane * this.plane
        this.bladeWidthRatio = 1.5
        this.bladeHeightRatio = 4
        this.positionRandomness = 0.5
        this.bladeHeightRandomness = 0.5
        
        this.setGeometry()
        this.setMaterial()
        this.setGrass()
    }

    setGeometry()
    {
        // position
        const position = new Float32Array(this.count * 3 * 2)
        const heightRandomness = new Float32Array(this.count * 3)

        for(let x = 0; x < this.plane; x++)
        {
            const normalizeX = (x / this.plane - 0.5)

            for(let z = 0; z < this.plane; z++)
            {
                const normalizeZ = (z / this.plane - 0.5)
                
                // indexs: 2D to 1D row * width + column
                const i = normalizeX * this.plane + normalizeZ

                // random height
                const i3 = i * 3

                // position
                const i6 = i * 6

                // blade
                const positionX = normalizeX + (Math.random() - 0.5)
                const positionZ = normalizeZ + (Math.random() - 0.5)

                position[i6] = positionX
                position[i6 + 1] = positionZ
                position[i6 + 2] = positionX
                position[i6 + 3] = positionZ
                position[i6 + 4] = positionX
                position[i6 + 5] = positionZ

                heightRandomness[i3] = Math.random()
                heightRandomness[i3 + 1] = Math.random()
                heightRandomness[i3 + 2] = Math.random()

                this.geometry = new THREE.BufferGeometry()
                this.geometry.boundingSphere = new THREE.Sphere(new THREE.Vector3(), 1)
                this.geometry.setAttribute('position', new THREE.Float32BufferAttribute(position, 3))
                this.geometry.setAttribute('heightRandomness', new THREE.Float32BufferAttribute(heightRandomness, 1))

            }
        }
    }

    setMaterial()
    {

    }

    setGrass()
    {

    }


    update()
    {

    }
}