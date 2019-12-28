class PriceReport extends FurniturePriceReport{
	int tilecount;				// the amount of tiles which are active in the grid
	int pricepertile;			// price per tile in the grid

	PriceReport(int tilecount, int pricepertile, int[] furnitureids, int[] furniturecounts) {
		super(furnitureids, furniturecounts);
		this.tilecount = tilecount;
		this.pricepertile = pricepertile;
	}
	PriceReport(int tilecount, int pricepertile, FurniturePriceReport fpr) {
		super(fpr.furnitureids, fpr.furniturecounts);
		this.tilecount = tilecount;
		this.pricepertile = pricepertile;
	}
}
class FurniturePriceReport {
	int[] furnitureids;			// ids of the furnitures in the grid
	int[] furniturecounts;		// amounts of the furnitures in the grid

	FurniturePriceReport(int[] furnitureids, int[] furniturecounts) {
		this.furnitureids = furnitureids;
		this.furniturecounts = furniturecounts;
	}
}