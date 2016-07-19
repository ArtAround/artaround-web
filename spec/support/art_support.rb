def create_approved_art title='The Bean'
  art = Art.create title: 'The Bean',
    address: '360 S Water',
    state: 'IL',
    city: 'Chicago',
    approved: true
  art.approved = true
  art.save!
  art
end
