const FiduceDeal = artifacts.require("FiduceDeal");



contract("FiduceDeal", async accounts => {
  let FiduceDealInstance =  FiduceDeal.deployed();
  console.log(FiduceDealInstance);


  it("Test FiduceDeal", () =>{
        // console.log(FiduceDealInstance);
      assert.equal(0,0);
    }
  );
});
