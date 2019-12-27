class PriceReport {
	int tilecount;				// the amount of tiles which are active in the grid
	int pricepertile;			// price per tile in the grid
	int[] furnitureids;			// ids of the furnitures in the grid
	int[] furniturecounts;		// amounts of the furnitures in the grid

	PriceReport(int tilecount, int pricepertile, int[] furnitureids, int[] furniturecounts) {
		this.tilecount = tilecount;
		this.pricepertile = pricepertile;
		this.furnitureids = furnitureids;
		this.furniturecounts = furniturecounts;
	}
	PriceReport(int tilecount, int pricepertile, FurniturePriceReport fpr) {
		this.tilecount = tilecount;
		this.pricepertile = pricepertile;
		this.furnitureids = fpr.furnitureids;
		this.furniturecounts = fpr.furniturecounts;
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