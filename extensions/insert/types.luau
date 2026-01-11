export type Inserter = (product: ProductInfo) -> Instance
export type InsertOptions = { label: string, insert: Inserter }

export type ProductInfo = {
	Name: string,
	Description: string,
	PriceInRobux: number,
	ProductId: number,
	ProductType: string,
	Created: string,
	Updated: string,
	ContentRatingTypeId: number,
	MinimumMembershipLevel: number,
	IsPublicDomain: boolean,
	TargetId: number,

	AssetId: number,
	AssetTypeId: number,
}

return nil
