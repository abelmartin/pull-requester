fixture.preload 'home/index_fixture.html'
describe 'QuickAssigner', ->
  assigner = null

  beforeEach ->
    fixture.load 'home/index_fixture.html'
    assigner = new QuickAssigner()

  it 'provides sanity', ->
    expect(true).toBe(true)

  describe '#start', ->
    it 'works'

  describe '#assign_user', ->
    it 'works'