from django.contrib import admin
from .models import Pharmacy, Group


# unregister the default one
admin.site.unregister(Group)

# then register your custom version
@admin.register(Group)
class CustomGroupAdmin(admin.ModelAdmin):
    list_display = ("name",)
    search_fields = ('name',)

@admin.register(Pharmacy)
class PharmacyAdmin(admin.ModelAdmin):
    list_display = ('name','brand','group','cost_status','manufactureDate','expiryDate','uuid', 'is_read')
    search_fields = ('name','brand','group','cost_status')
    list_editable = ('group','cost_status', 'is_read')
    readonly_fields = ('uuid','created_at','updated_at')
    autocomplete_fields = ["group"]
