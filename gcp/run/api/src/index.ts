import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import axios from 'axios'
import { Contract } from 'ethers'

if (process.env.NODE_ENV === 'development') {
    dotenv.config()
}
const apiClient = axios.create({
    baseURL: 'https://api.opensea.io/api/v1',
    headers: {
        Accept: 'application/json',
        'X-API-KEY': process.env.OPENSEA_API_KEY as string
    }
})

const PORT = process.env.PORT || 8080
const app: express.Express = express()

app.use(cors())
app.use(express.json())

type AssetContract = {
    name: string
    symbol: string
    address: string
    image_url: string
    external_link: string
    description: string
}

type Asset = {
    token_id: string
    image_url: string
    image_original_url: string
    animation_url: string
    animation_original_url: string
    name: string
    external_link: string
    asset_contract: AssetContract
    description: string
    owner: string
    contract: Contract
}

async function recursiveCallAssets(
    owner: string,
    page: number,
    assets: Array<Asset>
): Promise<Array<Asset>> {
    try {
        const { data } = await apiClient.get('/assets', {
            params: {
                owner,
                limit: 20,
                offset: page,
                order_direction: 'desc'
            }
        })
        if (data.assets.length === 0) {
            return assets
        }
        const tokens = data.assets.map((r: Asset) => {
            return {
                token_id: r.token_id,
                image_url: r.image_url,
                image_original_url: r.image_original_url,
                animation_url: r.animation_url,
                animation_original_url: r.animation_original_url,
                name: r.name,
                description: r.description,
                external_link: r.external_link,
                contract: {
                    name: r.asset_contract.name,
                    address: r.asset_contract.address,
                    symbol: r.asset_contract.symbol,
                    image_url: r.asset_contract.image_url,
                    external_link: r.asset_contract.external_link,
                    description: r.asset_contract.description
                }
            }
        })
        const nextPage = page + 20
        Array.prototype.push.apply(assets, tokens)
        return await recursiveCallAssets(owner, nextPage, assets)
    } catch (e) {
        console.log(e)
        return []
    }
}

app.get('/assets', async (req, res) => {
    const { owner, a } = req.query
    if (a !== process.env.API_KEY) {
        return res.status(401).send()
    }
    try {
        const assets = await recursiveCallAssets(owner as string, 0, [])
        return res.json({ assets })
    } catch (e) {
        console.log(e)
        return res.status(500).send()
    }
})

app.get('/*', async (_req, res) => {
    res.status(404).send()
})

app.listen(PORT, () => {
    console.log('Listening on port', PORT)
})
