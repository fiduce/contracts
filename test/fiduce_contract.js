const Fiduce = artifacts.require("Fiduce");



contract("Fiduce", accounts => {
  it("Token symbol shuld be FIDUCE", () =>
    Fiduce.deployed()
    .then(instance => {
      instance.symbol().then(symbol => {
        assert.equal( symbol , "FIDUCE", "Token symbol is not correct");
      })
    })
  );
});






contract("Fiduce", async accounts => {
  it("Create new deal", async () => {
    let instance = await Fiduce.deployed();

    let evnt = instance.NewDeal({}, (deal)=>{ assert.equal(0, 0)});
    await instance.createDeal(accounts[1]);
  })
});
