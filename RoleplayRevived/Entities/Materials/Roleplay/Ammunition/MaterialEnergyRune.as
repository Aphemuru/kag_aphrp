
void onInit(CBlob@ this)
{
  if (getNet().isServer())
  {
    this.set_u16('decay time', 20);
  }

  this.maxQuantity = 12;

  this.getCurrentScript().runFlags |= Script::remove_after_this;
}
