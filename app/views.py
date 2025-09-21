# from rest_framework import generics
# from .models import Pharmacy
# from .serializers import PharmacySerializer
#
# class PharmacyDetailView(generics.RetrieveAPIView):
#     queryset = Pharmacy.objects.all()
#     serializer_class = PharmacySerializer
#     lookup_field = 'uuid'
#
#     def get_object(self):
#         obj = super().get_object()
#         # Mark as read only if it's the first time
#         if not obj.is_read:
#             obj.is_read = True
#             obj.save(update_fields=['is_read'])
#         return obj

from rest_framework.response import Response
from rest_framework import generics
from .models import Pharmacy
from .serializers import PharmacySerializer
from .blockchain import add_block, create_genesis_block, Block


class PharmacyDetailView(generics.RetrieveAPIView):
    queryset = Pharmacy.objects.all()
    serializer_class = PharmacySerializer
    lookup_field = "uuid"

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()

        # ensure genesis exists
        create_genesis_block()

        # add block for this pharmacy UUID
        new_block = add_block(str(instance.uuid))

        data = self.get_serializer(instance).data
        data.pop("group", None)
        # get other pharmacies from the same category
        recommendations = (
            Pharmacy.objects
            .filter(group=instance.group)
            .exclude(name=instance.name)[:5]
        )

        recommendations_data = [
            {
                "name": rec.name,
                "brand": rec.brand,
                "cost_status": rec.cost_status,
                "imageExample": rec.imageExample.url if rec.imageExample else None
            }
            for rec in recommendations
        ]
        data["recommendations"] = recommendations_data


        response = {
            "pharmacy": data,
            "latest_block": {
                "index": new_block.index,
                "timestamp": new_block.timestamp,
                "data": new_block.data,
                "previous_hash": new_block.previous_hash,
                "hash": new_block.hash,
            }

        }
        # ✅ Mark is_read True only if it's still False
        if not instance.is_read:
            instance.is_read = True
            instance.save(update_fields=["is_read"])
        return Response(response)
