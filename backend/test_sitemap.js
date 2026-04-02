const mockPool = {
  query: jest.fn(),
};

// Simulate the route
mockPool.query.mockImplementation(() =>
  Promise.resolve({
    rows: [{ id: 1 }, { id: 2 }, { id: 42 }],
  })
);

(async () => {
  const result = await mockPool.query('SELECT id FROM airplanes ORDER BY id ASC');
  console.log('Mock result:', result);
  console.log('Rows:', result.rows);
})();
