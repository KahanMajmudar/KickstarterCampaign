import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0xf22f4b0b96cECE88E913EFC295061164BC9dBe51'
);

export default instance;
