from rest_framework import serializers
from .models import Pharmacy

class PharmacySerializer(serializers.ModelSerializer):
    class Meta:
        model = Pharmacy
        fields = '__all__'
        read_only_fields = ('uuid','created_at','updated_at')

    def validate(self, data):
        m = data.get('manufactureDate', getattr(self.instance, 'manufactureDate', None))
        e = data.get('expiryDate', getattr(self.instance, 'expiryDate', None))
        if m and e and e <= m:
            raise serializers.ValidationError("expiryDate must be after manufactureDate")

        gtin = data.get('gtin', None)
        if gtin:
            # simple GTIN validation: numeric and length 8,12,13 or 14
            if not gtin.isdigit() or len(gtin) not in (8,12,13,14):
                raise serializers.ValidationError({'gtin': 'GTIN must be numeric and 8, 12, 13 or 14 digits long.'})
        return data
