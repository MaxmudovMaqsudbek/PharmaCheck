from .models import Block
import time

def get_latest_block():
    return Block.objects.order_by("-index").first()

def create_genesis_block():
    if not Block.objects.exists():
        genesis = Block(
            index=0,
            timestamp=time.time(),
            data="Genesis Block",
            previous_hash="0"
        )
        genesis.save()
        return genesis
    return get_latest_block()

def add_block(data):
    latest = get_latest_block()
    if not latest:
        latest = create_genesis_block()

    new_block = Block(
        index=latest.index + 1,
        timestamp=time.time(),
        data=data,
        previous_hash=latest.hash
    )
    new_block.save()
    return new_block
