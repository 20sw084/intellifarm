class Harvest {
  String? harvestDate;
  String? plantingToHarvest;
  int? quantityHarvested;
  String? batchNumber;
  String? harvestQuality;
  String? finalHarvest;
  int? quantityRejected;
  int? unitCost;
  int? incomeFromThisHarvest;
  String? notes;
  Harvest({
    required this.harvestDate,
    required this.plantingToHarvest,
    required this.quantityHarvested,
    this.batchNumber,
    this.harvestQuality,
    required this.finalHarvest,
    this.quantityRejected,
    this.unitCost,
    this.incomeFromThisHarvest,
    this.notes,
  });
  Map<String, dynamic> getHarvestDataMap() {
    return {
      "harvestDate": harvestDate,
      "plantingToHarvest": plantingToHarvest,
      "quantityHarvested": quantityHarvested,
      "batchNumber": batchNumber ?? " ",
      "harvestQuality": harvestQuality ?? " ",
      "finalHarvest": finalHarvest,
      "quantityRejected": quantityRejected ?? " ",
      "unitCost": unitCost ?? " ",
      "incomeFromThisHarvest": incomeFromThisHarvest ?? " ",
      "notes": notes ?? " ",
    };
  }
}
