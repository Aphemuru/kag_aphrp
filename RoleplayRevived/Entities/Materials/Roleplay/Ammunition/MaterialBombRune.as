
void onInit(CBlob@ this)
{
  if (getNet().isServer())
  {
    this.set_u16('decay time', 30);
  }

  this.maxQuantity = 1;

  this.getCurrentScript().runFlags |= Script::remove_after_this;
}
